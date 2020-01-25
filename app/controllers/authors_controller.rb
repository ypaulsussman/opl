# frozen_string_literal: true

class AuthorsController < ApplicationController
  AUTHOR_CREATED_MESSAGE = 'Author was successfully created. Let\'s give them a quote!'

  before_action :confirm_admin, except: [:index, :show]
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  def index
    if params[:sort_by] == 'name'
      @sort_sql = 'slug ASC, quotes_count DESC'
      @current_sort = 'name'
    else
      @sort_sql = 'quotes_count DESC, slug ASC'
      @current_sort = 'quotes'
    end

    @authors = Author.order(@sort_sql).page(params[:page]).per(36)

    # Yes, this is gross: tl;dr it turns (the AR Relation of authors) into a nested array,
    # with the inner arrays each containing three (or, in the final case, 1-3) author-records.
    @authors_in_threes = @authors.to_a.each_with_object([]).with_index do |(author, ait_agg), i|
      if (i % 3).zero?
        ait_agg.push([author])
      else
        ait_agg[-1].push(author)
      end
    end
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
      redirect_to new_quote_path(author_id: @author.id), flash: { success: AUTHOR_CREATED_MESSAGE }
    else
      render :new
    end
  end

  # PATCH/PUT /authors/{slug}
  def update
    if @author.update(author_params)
      redirect_to @author, flash: { success: 'Author was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /authors/{slug}
  def destroy
    @author.destroy!
    redirect_to authors_url, flash: { info: 'Author was successfully destroyed.' }
  end

  private

  def set_author
    @author = Author.find_by(slug: params[:slug])
  end

  def author_params
    ap = params
         .fetch(:author, {})
         .permit(:name, :sort_by, quote_attributes: [:passage, :id, :_destroy])
    ap.each { |_k, v| v.strip! if v.respond_to?('strip!') }
  end
end
