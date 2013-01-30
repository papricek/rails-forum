class CategoriesController < ApplicationController
  helper 'forums'
  load_and_authorize_resource :class => 'Category'
end
