class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  # GET /authors.json
  def index
    @authors =
      Author
      .order(quotes_count: :desc, sortable_name: :asc)
      .page(params[:page])
  end

  # GET /authors/{uuid}
  # GET /authors/{uuid}.json
  def show
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/{uuid}/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: 'Author was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/{uuid}
  # PATCH/PUT /authors/{uuid}.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: 'Author was successfully updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/{uuid}
  # DELETE /authors/{uuid}.json
  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: 'Author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.fetch(:author, {}).permit(:name, quote_attributes: [:passage, :id, :_destroy])
  end
end
