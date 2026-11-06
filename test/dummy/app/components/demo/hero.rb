# frozen_string_literal: true

class Demo::Hero < OrbitalUi::Component
  orb_template <<-ORB
    <div class="flex flex-col">
      <section class="border-grid">
        <div class="container-wrapper">
          <div class="container flex flex-col items-center gap-2 py-8 text-center md:py-16 lg:py-20 xl:gap-4 mx-auto">
            {{content}}
          </div>
        </div>
      </section>
    </div>
  ORB
end
