require 'test_helper'
require 'crud_test_model'
require File.join(File.dirname(__FILE__), 'crud_controller_test_helper')

class CrudTestModelsControllerTest < ActionController::TestCase
  
  include CrudControllerTestHelper
  include CrudTestHelper
  
  attr_accessor :models
  
  setup :reset_db, :setup_db, :create_test_data
  
  teardown :reset_db
  
  def test_setup
    assert_equal 6, CrudTestModel.count
    assert_equal CrudTestModelsController, @controller.class
    assert_recognizes({:controller => 'crud_test_models', :action => 'index'}, '/crud_test_models')
    assert_recognizes({:controller => 'crud_test_models', :action => 'show', :id => '1'}, '/crud_test_models/1')
  end
  
  def test_index
    super
    assert_equal 6, assigns(:entries).size
    assert_equal assigns(:entries).sort_by {|a| a.name }, assigns(:entries)
  end
  
  def test_create
    super
    assert_equal [:before_create, :before_save, :after_save, :after_create], @controller.called_callbacks
  end
  
  def test_update
    super
    assert_equal [:before_update, :before_save, :after_save, :after_update], @controller.called_callbacks
  end
  
  def test_destroy
    super
    assert_equal [:before_destroy, :after_destroy], @controller.called_callbacks
  end
  
  def test_create_with_before_callback
    assert_no_difference("#{model_class.name}.count") do
      post :create, :crud_test_model => {:name => 'illegal', :children => 2}
    end
    assert_template 'new'
    assert assigns(:entry).new_record?
    assert flash[:error].present?
    assert_equal 'illegal', assigns(:entry).name
    assert_nil @controller.called_callbacks
  end
  
  
  protected 
  
  def test_entry
    crud_test_models(:AAAAA)
  end
  
  def test_entry_attrs
    {:name => 'foo', 
     :children => 42, 
     :companion_id => 3,
     :rating => 99.99, 
     :income => 2.42, 
     :birthdate => '31-12-1999'.to_date,
     :human => true,
     :remarks => "some custom\n\tremarks"}
  end
  
end