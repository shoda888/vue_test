class BooksController < ApplicationController
  def index
    @books = Book.all
  end
  def edit
    @book = Book.first
  end
  def create
  end
end
