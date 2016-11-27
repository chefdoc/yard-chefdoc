require 'spec_helper'

describe 'home page' do
  before(:each) do
    visit('/docs/recipe/default')
  end

  it 'shows the description' do
    expect(page).to have_content('This is the description for the default recipe')
  end
end
