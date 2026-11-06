# frozen_string_literal: true

module OrbitalUi
  class DialogFrame < Component
    orb_template <<-ORB
      <turbo-frame id={portal_id}>
        {{content}}
      </turbo-frame>
    ORB

    private

    def portal_id
      OrbitalUi.configuration.dialog_portal_id
    end
  end
end
