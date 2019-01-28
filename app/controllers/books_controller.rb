class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :library]

  def index
    @books = Book.all
  end

  def show
  end

  def new
    @book = current_user.books.new
  end

  def edit
  end

  def create
    @book = current_user.books.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # add and remove books to/from library for current_user
  def library
    type = params[:type] 

    if type == 'add'
      current_user.library_additions <<  @book
      redirect_to library_index_path, notice: "#{@book.title} added to your library"
    elsif type == 'remove'
      current_user.library_additions.delete(@book)
      redirect_to root_path, notice: "#{@book.title} has been removed from your library"
    else
      redirect_to @book, notice: 'Looks like nothing happened'
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :description, :thumbnail, :author, :user_id)
    end
end
