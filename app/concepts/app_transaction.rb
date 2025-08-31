# frozen_string_literal: true

class AppTransaction
  extend Uber::Callable

  def self.call(options, *)
    ActiveRecord::Base.transaction { yield } # yield runs the nested pipe.
    # return value decides about left or right track!
  end
end
