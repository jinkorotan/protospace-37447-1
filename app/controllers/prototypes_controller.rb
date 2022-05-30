class PrototypesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  # ログインしていないユーザーをログインページの画面に促す
  before_action :contributor_confirmation, only: [:edit, :update,:destroy]
   #ログインしていない状態で新規投稿画面へ直接アクセスしようとしても
   #before_actionによりcontributor_confirmationメソッドが先に実行され
   #トップページにリダイレクトする

  def index
    @prototypes= Prototype.includes(:user)
    #includesメソッドを使用してN+1問題を解消
    #includesメソッドを使用するとすべてのレコードを取得するため、allメソッドは省略
  end

  def new
    @prototype= Prototype.new
     #@prototypeは空の状態。
     #新規作成ボタンをクリックしたらnewアクションが働く
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype .save
      #保存に成功したら
      redirect_to root_path
      #redirect_toメソッドでルートパスにリダイレクト
    else
      render :new
      #current_user.createに失敗したら
      #保存が失敗した場合はrenderメソッドでprototype/new.html.erbのページを表示
    end
  end 

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
       redirect_to prototype_path(@prototype)
    else
       render :edit
        #更新が失敗した場合はrenderメソッドでprototype.edit.html.erbのページを表示
    end
  end


  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end  
  end


  private
    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    
    end


    def contributor_confirmation
      @prototype = Prototype.find(params[:id])
      redirect_to root_path unless current_user == @prototype.user
      # ユーザーがログインしていなかったらcontributor_confirmationアクションが実行される
    end
end
