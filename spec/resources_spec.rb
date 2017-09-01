require 'spec_helper'

describe 'home page' do
  before(:each) do
    visit('/docs/resource/etc_dir')
  end

  it 'shows the default_action as create' do
    expect(page).to have_content('Default action: create')
  end
end
