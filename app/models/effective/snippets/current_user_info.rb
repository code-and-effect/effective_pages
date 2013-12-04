module Effective
  module Snippets
    class CurrentUserInfo < Snippet
      attribute :method, String

      def value_type
        String
      end

      def snippet_name
        'Current User Info'
      end

      def snippet_image
        '/assets/effective_pages/current_user_info.png'
      end

      def snippet_description
        'Inserts info as per current_user'
      end

    end
  end
end
