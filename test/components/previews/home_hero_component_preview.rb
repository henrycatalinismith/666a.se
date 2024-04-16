class HomeHeroComponentPreview < ViewComponent::Preview
  def home_hero
    render(HomeHeroComponent.new())
  end
end
