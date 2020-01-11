# frozen_string_literal: true

class AuthorsController < ApplicationController
  AUTHOR_CREATED_MESSAGE = 'Author was successfully created. Let\'s give them a quote!'

  before_action :confirm_admin, except: [:index, :show]
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  def index
    # @Y: use for sort toggle
    # by_name = 'slug ASC, quotes_count DESC'
    by_quotes_count = 'quotes_count DESC, slug ASC'
    @authors =
      Author
      .order(by_quotes_count)
      .page(params[:page])
  end

  # GET /authors/{slug}
  def show; end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/{slug}/edit
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

  # PATCH/PUT /authors/{slug}
  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'Author was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /authors/{slug}
  def destroy
    @author.destroy!
    redirect_to authors_url, notice: 'Author was successfully destroyed.'
  end

  private

  def set_author
    @author = Author.find_by(slug: params[:slug])
  end

  def author_params
    params.fetch(:author, {}).permit(:name, quote_attributes: [:passage, :id, :_destroy])
  end
end
