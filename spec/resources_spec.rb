require 'spec_helper'

describe 'home page' do
  before(:each) do
    visit('/docs/attribute/default')
  end

  it 'shows the description' do
    expect(page).to have_content('Some default attributes')
  end

  it 'has the test-attribute1' do
    expect(page).to have_content("['test-cookbook1']['test-attribute1']")
  end

  it 'has the test-attribute1 description' do
    expect(page).to have_content('This is the documentation of an attribute')
  end
end
