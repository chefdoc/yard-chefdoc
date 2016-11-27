require 'spec_helper'

describe 'home page' do
  before(:each) do
    visit('/')
  end

  it 'presents the README' do
    expect(page).to have_content('TODO: Enter the cookbook description here.')
  end

  it 'shows the recipe summary' do
    expect(page).to have_content('Recipes summary')
    expect(page).to have_content('Installs the system package for some_service')
  end

  it 'shows the attribute summary' do
    expect(page).to have_content('Attributes summary')
  end

  it 'gives an overview of the libraries' do
    expect(page).to have_content('Finder')
    expect(page).to have_content('Finder::Node')
    expect(page).to have_content('MyTestLib')
  end
end
