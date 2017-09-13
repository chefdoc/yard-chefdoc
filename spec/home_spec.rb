require 'spec_helper'

describe 'home page' do
  before(:each) do
    visit('/')
  end

  it 'presents the README' do
    expect(page).to have_content('Lorem ipsum dolor sit amet')
  end

  it 'shows metadata version' do
    expect(page).to have_tag('td', text: '0.1.0')
  end

  it 'does not show empty license' do
    expect(page).to_not have_tag('td', text: 'License')
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

  it 'shows cookbook documentation table' do
    expect(page).to have_content('Cookbook documentation statistics')
  end

  it 'shows overall percentage' do
    expect(page).to have_content('Total percentage 86.96%')
  end
end
