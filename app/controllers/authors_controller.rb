# frozen_string_literal: true

class AuthorsController < ApplicationController
  AUTHOR_CREATED_MESSAGE = 'Author was successfully created. Let\'s give them a quote!'

  before_action :confirm_admin, except: [:index, :show]
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  def index
    @authors =
      Author
      .order(quotes_count: :desc, sortable_name: :asc)
      .page(params[:page])
  end

  # GET /authors/{uuid}
  def show; end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/{uuid}/edit
  def edit; end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to new_quote_path(author_id: @author.id), notice: AUTHOR_CREATED_MESSAGE
    else
      render :new
    end
  end

  # PATCH/PUT /authors/{uuid}
  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'Author was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /authors/{uuid}
  def destroy
    @author.destroy!
    redirect_to authors_url, notice: 'Author was successfully destroyed.'
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.fetch(:author, {}).permit(:name, quote_attributes: [:passage, :id, :_destroy])
  end
end
