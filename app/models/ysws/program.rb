module Ysws
  class Program < ApplicationRecord
    self.primary_key = 'airtable_id'

    has_many :approved_projects,
             class_name: 'Ysws::ApprovedProject',
             foreign_key: :ysws_program_id,
             dependent: :nullify
  end
end
