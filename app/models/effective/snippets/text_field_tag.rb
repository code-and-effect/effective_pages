module Effective
  module Snippets
    class TextFieldTag < Snippet
      attribute :name, String
      attribute :required, Boolean
      attribute :maxlength, Integer
      attribute :placeholder, String
      attribute :html_class, String
    end
  end
end
