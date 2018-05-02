# require 'qiniu'

class ApiController < ApplicationController
  before_action :authenticate, except: [:test, :user_create, :signin, :post_id]

  def home
    redirect_to '/pgtab/index.html'
    # redirect_to 'http://localhost:9000/422.html'
  end

  def user_create
    render json:{err:"pw not equal"} and return unless params["password"] === params["password_confirmation"]
    # user = User.new(name: params["name"], email: params["email"], password: params["password"], avatar:params["avatar"], nationality:params["nationality"], city:params["city"], age:params["age"].to_i, telenumber:params["telenumber"], description:params["description"])
    user = User.new(user_params)
    user.valid?? (user.save ; render json:{token: user.password_digest}):(render json:{err: user.errors.messages})
    # p user.valid? ; p user.errors ;p user.errors.full_messages ;p user.errors.messages
  end

  def user_id
    if params['page'].to_i == 0
      last_id =  Post.first.id + 1 ; user = User.find(params['id'].to_i).as_json() ; foing = @api_user.is_foing.include?(params['id'].to_i)? true:false
    else
      last_id = params['lastId'].to_i ; user = false ; foing = false
    end
    posts = Post.where(user_id: params['id']).where("id < ? and hidden is not true", last_id).limit(5).includes(:comments).as_json(:methods => :comments_c) # .offset(params["page"].to_i*5)
    render json:{user: user, posts:posts, foing: foing}
  end
  def user_up_id
    render json:{user:@api_user}
  end
  def user_up
    @api_user.name = params['name'] unless params['name'] == nil
    @api_user.email = params['email'] unless params['email'] == nil
    @api_user.telenumber = params['telenumber'] unless params['telenumber'] == nil
    @api_user.avatar = params['avatar'] unless params['avatar'] == nil
    @api_user.nationality = params['nationality'] unless params['nationality'] == nil
    @api_user.city = params['city'] unless params['city'] == nil
    @api_user.description = params['description'] unless params['description'] == nil
    if @api_user.save(validate: false)
      render json:{suc:'ok'}
    else
      p @api_user.errors.messages
    end
  end

  def blog_index
    user = User.find_by(email:'gongsongping@gmail.com') #user = User.find(1)
    params['page'].to_i == 0 ?(last_id =  Post.first.id + 1):(last_id = params['lastId'].to_i)
    posts = Post.where(user_id: user.id).where("id < ? and hidden is not true", last_id).limit(5).includes(:comments).as_json(:methods => :comments_c) # .offset(params["page"].to_i*5)
    render json:posts
  end

  def follow_create
    Stalkertarget.create(stalker_id: @api_user.id, target_id: params['id'].to_i)
    @api_user.is_foing.push(params['id'].to_i) # @api_user.name = 'binh' # @api_user.update_attribute(:name, "dd")
    @api_user.save(validate: false)
    render json:{suc:"ok"}
  end

  def follow_id
    Stalkertarget.where(stalker_id: @api_user.id).where(target_id: params['id'].to_i).first.destroy!
    @api_user.is_foing.delete(params['id'].to_i) # @api_user.blog = 'blogblog'
    @api_user.save(validate: false)
    render json:{suc:'ok'} # render "api/post_id"
  end

  def signin
    user = User.find_by(email: params["email"].downcase)
    return render json:{err: "no such user"}  unless user
    return render json:{err: "pw not right"} unless user.authenticate(params["password"])
    render json:{token: user.password_digest}
  end

  def post_index
    params['page'].to_i == 0? (last_id = Post.first.id + 1):(last_id = params["lastId"].to_i)
    # @posts = Post.where(user_id: @api_user.is_foing.push(@api_user.id)).where("id < ?", last_id)
    posts = Post.where("user_id in (?) and id < ? and hidden is not true", @api_user.is_foing.push(@api_user.id),last_id)
    .limit(5).includes(:user, :comments) # .offset(params["page"].to_i*5)
    render json:posts.as_json(:include => :user, :methods => :comments_c) # render "post_index"
  end
  def post_discover
    posts =  Post.reorder("RANDOM()").limit(5)
    render json:posts.as_json(:include => :user, :methods => :comments_c)
  end
  def hiddenposts
    params['page'].to_i == 0? (last_id = Post.first.id + 1):(last_id = params["lastId"].to_i)
    posts = Post.where("user_id = ? and id < ? and hidden is true", @api_user.id, last_id).limit(5)
    render json:posts
  end

  def post_create
    if params['key'].nil?
      url = ''
    else
      url =  "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key']
    end
    post = @api_user.posts.build({content:params["content"], hidden: params["hidden"], url: url})
    if post.save
      render json:{suc:"suc"}
    end
  end

  def post_id
    if params['page'].to_i == 0
      last_id = Comment.first.id + 1 ; post = Post.where(id: params['id']).includes(:user).first.as_json(:include => :user)
    else
      last_id = params['lastId'].to_i ; post = false
    end
    comments = Comment.where(post_id: params['id']).where("id < ?", last_id).limit(5).includes(:user).as_json(:include => :user) # .offset(params["page"].to_i*5)
    render json:{post: post, comments: comments}
  end

  def comment_create
    comment = Comment.new(content: params['content'], post_id: params['postId'], user_id: @api_user.id)
    if comment.save
      render json:{suc:"ok"}
    end
  end
  def photo_create
    photo = Photo.new(url: "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key'],user_id: @api_user.id)
    if photo.save
      render json:{suc:"ok"}
    end
  end
  def photo_index
    # users = User.order("RANDOM()").take(5) ; photos = []
    # photos = Photo.all.sample(5) # arr = Photo.find_by_sql("select id from photos order by RANDOM() limit 5") ; p arr # photos = Photo.find(arr)
    # photos =  Photo.reorder("RANDOM()").limit(6)
    # render json:photos.as_json(:include => :user)
    if params["nationality"] == nil
      photos =  Photo.reorder("RANDOM()").limit(6)
      render json:photos.as_json(:include => :user)
    else
      p params["nationality"]
      user_ids = User.where(nationality: params["nationality"]).order("RANDOM()").limit(6).pluck(:id)
      photos =  Photo.where(user_id: user_ids).limit(6)
      render json:photos.as_json(:include => :user)
    end
  end
  def partner_id
    params['page'].to_i == 0? (last_id = Photo.first.id + 1):(last_id = params["lastId"].to_i)
    params['id'].to_i == 0? (user = @api_user):(user = User.find(params['id'].to_i))
    photos = Photo.where("user_id = ? and id < ?", user.id ,last_id).limit(5)
    #.includes(:user)#.as_json(:include => {:user => {:only => [:id, :name, :email, :avatar],:methods => []}})
    if params['page'].to_i == 0
      render json:{photos: photos, user: user, s_askers: user.s_askers, s_targets: user.s_targets, partners: user.partners}
    else
      render json:{photos: photos}
    end
  end
  def stranger_id
    user = User.find(params['id'].to_i)
    photos = user.photos.first(2) << user.photos.last #user.photos.first(2) << user.photos.last,user.photos.last(2) + user.photos.first(2), .sample(3)
    render json:{photos:photos, user: user, s_asker_q:user.s_asker?(@api_user), s_target_q:user.s_target?(@api_user), partner_q:user.partner?(@api_user)}
  end
  def asker_create
    at = Askertarget.new(asker_id: @api_user.id, target_id:params['id'].to_i)
    if at.save
      render json:{suc:'ok'}
    end
  end
  def agree_create
    at = Askertarget.where("asker_id = ? and target_id = ?", params['id'].to_i, @api_user.id).first
    at.agree = true
    if at.save(validate: false)
      render json:{suc:'ok'}
    end
  end
  def unagree_create
    # at = Askertarget.where("asker_id = ? and target_id = ? and agree is true", params['id'].to_i, @api_user.id).first
    # at.agree = false # if at.save(validate: false) #  render json:{suc:'ok'} # end
    at1 = Askertarget.where("asker_id = ? and target_id = ? and agree is true", params['id'].to_i, @api_user.id).first
    at2 = Askertarget.where("asker_id = ? and target_id = ? and agree is true", @api_user.id, params['id'].to_i).first
    at1.destroy if at1 ; at2.destroy if at2
    render json:{suc:'ok'}
  end

  def cafe_create
    # photo = Photo.new(url: "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key'],user_id: @api_user.id)
    cafepost = @api_user.cafeposts.build({content:params["content"], url: "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key']})
    if cafepost.save
      p cafepost
      render json:{suc:"ok"}
    end
  end
  def cafe_index
    photos =  Cafepost.reorder("RANDOM()").limit(6)
    render json:photos.as_json(:include => :user)
  end
  def cafe_id
    params['page'].to_i == 0? (last_id = Cafepost.first.id + 1):(last_id = params["lastId"].to_i)
    params['id'].to_i == 0? (user = @api_user):(user = User.find(params['id'].to_i))
    photos = Cafepost.where("user_id = ? and id < ?", user.id ,last_id).limit(5)
    if params['page'].to_i == 0
      render json:{photos: photos, user: user}
    else
      render json:{photos: photos}
    end
  end
  def product_create
    # photo = Photo.new(url: "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key'],user_id: @api_user.id)
    product = @api_user.products.build({content:params["content"], url: "http://7xj5ck.com1.z0.glb.clouddn.com/"+params['key']})
    if product.save
      # p product
      render json:{suc:"ok"}
    end
  end
  def product_index
    if params['city']
      # u_ids = User.order("RANDOM()").where(city:params['city']).limit(5).pluck(:id)
      u_ids = User.order("RANDOM()").where("city = '河口' or city = 'laocai'").limit(5).pluck(:id) if params['city'] == '河口' || params['city'] == 'laocai'
      u_ids = User.order("RANDOM()").where("city = '凭祥' or city = 'langson'").limit(5).pluck(:id) if params['city'] == '凭祥' || params['city'] == 'langson'
      u_ids = User.order("RANDOM()").where("city = '东兴' or city = 'mangcai'").limit(5).pluck(:id) if params['city'] == '东兴' || params['city'] == 'mangcai'
      photos = Product.reorder("RANDOM()").where(user_id: u_ids).limit(6)
    else
      photos =  Product.reorder("RANDOM()").limit(6)
    end
    render json:photos.as_json(:include => :user)
  end
  def product_id
    params['page'].to_i == 0? (last_id = Product.first.id + 1):(last_id = params["lastId"].to_i)
    params['id'].to_i == 0? (user = @api_user):(user = User.find(params['id'].to_i))
    photos = Product.where("user_id = ? and id < ?", user.id ,last_id).limit(5)
    if params['page'].to_i == 0
      render json:{photos: photos, user: user}
    else
      render json:{photos: photos}
    end
  end

  def qiniu_token
    # 已在某处调用Qiniu#establish_connection!方法
    put_policy = Qiniu::Auth::PutPolicy.new('gsplanguage')
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    render json:{uptoken: uptoken}
  end
  def test
    # posts = Stalkertarget.where(stalker_id: 3).pluck(:target_id)
    # posts = Stalkertarget.where(stalker_id: 3).select(:target_id)
    # p [1,2].many?, !!nil, ![].first ; k = [1,2,3]
    # posts = Stalkertarget.find_by_sql(["select target_id from stalkertargets where stalker_id = ?", k])
    # posts = Post.joins(:comments).where('posts.id in (?)',k) ; Product.where('id != ?', params[:id])   # posts = Comment.ids
    # posts = User.select('users.id, users.name, comments.content').joins(:comments).pluck(:content,:name)#.where('comments.created_at > ?', 1.day.ago)
    # posts = Post.take(2) ;    posts = {de:"de",er:"er"}.pluck(:de)
    # posts = Post.where(user: User.first)
    # posts = Post.select("date(created_at), posts.id").group("date(created_at)")
    # posts = Post.count(group: 'user_id')
    # posts = Post.find_by_sql('SELECT  posts.content, count(*) FROM posts where posts.user_id in  (1,2,3) group by posts.id')
    # posts = Post.find_by_sql('SELECT  posts.content, count(comments.id) FROM posts LEFT OUTER JOIN comments ON comments.post_id = posts.id where posts.user_id in  (1,2,3) group by posts.id')
    # Post.where('user_id = 1').each do |p|
    #   p.destroy
    # end
    posts = Post.find_by_sql('SELECT  posts.content, posts.id, users.name,users.email, count(comments.id) FROM posts
    left outer join users ON posts.user_id = users.id
    left outer join comments ON comments.post_id = posts.id  group by posts.id, users.name, users.email,users.id')
    # @posts = Post.all
    # render "p_index.json.jbuilder"
    render json:posts
  end

  protected
    def user_params
      params.require(:user).permit('name', 'email', 'password','password_confirmation',
      "avatar","nationality","city","age","telenumber","description")
    end
    def authenticate
      p request.headers["Authorization"]
      if request.authorization()
        token = request.authorization().split('=').last
        @api_user = User.find_by(password_digest: token)
      end
    end
end
