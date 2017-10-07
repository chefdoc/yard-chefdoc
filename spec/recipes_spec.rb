require 'spec_helper'

describe 'recipe::default' do
  before(:each) do
    visit('/docs/recipe/default')
  end

  it 'shows the description' do
    expect(page).to have_content('This is the description for the default recipe')
  end

  it 'shows the recipe file name and location' do
    expect(find(:xpath, "//span[@class='info file']").text).to eq('# File \'recipes/default.rb\'')
  end
end
