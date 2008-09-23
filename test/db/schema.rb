ActiveRecord::Schema.define(:version => 1) do
  create_table "events", :force => true do |t|
    t.string "title"
    t.text   "description"
  end
end
