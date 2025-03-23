module Ysws
  class ApprovedProject < ApplicationRecord
    self.primary_key = 'airtable_id'

    belongs_to :ysws_program,
               class_name: 'Ysws::Program',
               optional: true
  end
end
