# frozen_string_literal: true

class Demo::Page < OrbitalUi::Component
  attribute :title, :string, default: "Orbital Demo"

  renders_one :header

  orb_template <<-ORB
    <div class="bg-background relative z-10 min-h-svh px-2 pb-2">
      <header class="bg-background/90 backdrop-blur-sm border-b sticky top-0 z-50 w-full">
        <div class="container-wrapper 3xl:fixed:px-0 px-0">
          <div class="3xl:fixed:container flex h-(--header-height) items-center">
            {{header}}
          </div>
        </div>
      </header>
      {{content}}
    </div>
  ORB
end
