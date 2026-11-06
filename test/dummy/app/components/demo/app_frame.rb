# frozen_string_literal: true

class Demo::AppFrame < OrbitalUi::Component
  orb_template <<-ORB
    <div **html_attributes>
      <Page>
        <Page:Header>
          <NavigationMenu>
            <NavigationMenu:Brand>
              <Button variant="link" url="/" class="mr-2">
                <svg width="28" height="28" viewBox="0 0 390 390" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="194.5" cy="195.5" r="157" stroke="currentColor" stroke-width="8"/>
                  <circle cx="194.5" cy="195.5" r="90.42" stroke="currentColor" stroke-width="8"/>
                  <circle cx="194.5" cy="195.5" r="43.58" fill="currentColor"/>
                  <circle cx="297.39" cy="76.87" r="24.21" fill="currentColor"/>
                  <circle cx="118.39" cy="241.87" r="16" fill="currentColor"/>
                </svg>
                <Text weight="bold">Orbital</Text>
              </Button>
            </NavigationMenu:Brand>

            <NavigationMenu:Mobile>
              <Menu>
                <Menu:Item url="/components" icon="box">Components</Menu:Item>
                <Menu:Item url="/blocks" icon="layout-grid">Blocks</Menu:Item>
                <Menu:Item url="/themes" icon="palette">Themes</Menu:Item>
                <Menu:Item url="/colors" icon="paintbrush">Colors</Menu:Item>
                <Menu:Separator/>
                <Menu:Item url="https://github.com/kuyio/orb_template" icon="github">GitHub</Menu:Item>
                <Menu:Item url="https://kuy.io" icon="compass">kuy.io</Menu:Item>
              </Menu>
            </NavigationMenu:Mobile>

            <Button url="/components" variant="ghost">Components</Button>
            <Button url="/blocks" variant="ghost">Blocks</Button>
            <Dropdown label="Customization" variant="ghost">
              <Menu>
                <Menu:Item url="/themes" icon="palette">Themes</Menu:Item>
                <Menu:Item url="/colors" icon="paintbrush">Colors</Menu:Item>
              </Menu>
            </Dropdown>
            <Expander/>
            <Button variant="outline" class="font-normal w-52 justify-between!" data-action="click->command-palette#open">
              <Text tone=subdued>Search...</Text>
              <KbdGroup>
                <Kbd>⌘</Kbd>
                <Kbd>K</Kbd>
              </KbdGroup>
            </Button>
            <Separator orientation="vertical" class="h-8"/>
            <Button variant="ghost" size="icon" url="https://github.com/kuyio/orb_template">
              <Icon name="github"/>
            </Button>
            <Separator orientation="vertical" class="h-8"/>
            <Button variant="ghost" size="icon" url="https://kuy.io">
              <Icon name="compass"/>
            </Button>
            <Separator orientation="vertical" class="h-8"/>
            <div data-controller="dark-mode">
              <Button variant="ghost" size="icon" data-action="click->dark-mode#toggle">
                <span data-icon="moon"><Icon name="moon"/></span>
                <span data-icon="sun" style="display:none"><Icon name="sun"/></span>
              </Button>
            </div>
          </NavigationMenu>
        </Page:Header>

        {{content}}
      </Page>

      <dialog class="command-palette-dialog" data-command-palette-target="dialog" data-action="click->command-palette#backdropClick">
        <div class="command-palette">
          <div class="command-palette-header">
            <Icon name="search" size="sm" class="command-palette-search-icon"/>
            <input
              type="text"
              class="command-palette-input"
              placeholder="Search components, pages..."
              autocomplete="off"
              data-command-palette-target="input"
              data-action="input->command-palette#onInput keydown->command-palette#onKeydown"
            />
            <Kbd>ESC</Kbd>
          </div>
          <div class="command-palette-body" data-command-palette-target="results">
          </div>
        </div>
      </dialog>
    </div>
  ORB

  private

  def default_attributes
    super.merge(
      class: class_names(
        "Orbital-App"
      ),
      data: {
        controller: "command-palette"
      }
    )
  end
end
