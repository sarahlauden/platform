class CasInitialRubycasTables < ActiveRecord::Migration[6.0]
  def self.up
    create_table :login_tickets do |t|
      t.column :ticket,     :string,   :null => false
      t.column :created_on, :timestamp, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :consumed,   :datetime, :null => true
      t.column :client_hostname, :string, :null => false
    end

    create_table :service_tickets do |t|
      t.column :ticket,     :string,    :null => false
      t.column :service,    :string,    :null => false
      t.column :created_on, :timestamp, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :consumed,   :datetime, :null => true
      t.column :client_hostname, :string, :null => false
      t.column :username,   :string,  :null => false
      t.column :proxy_granting_ticket_id, :integer, :null => true
      t.column :ticket_granting_ticket_id, :integer, :null => true
    end

    create_table :ticket_granting_tickets do |t|
      t.column :ticket,     :string,    :null => false
      t.column :created_on, :timestamp, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :client_hostname, :string, :null => false
      t.column :username,   :string,    :null => false
      t.column :remember_me,   :string,    :null => false
      t.column :extra_attributes, :string, :null => false
    end

    create_table :proxy_granting_tickets do |t|
      t.column :ticket,     :string,    :null => false
      t.column :created_on, :timestamp, :null => false
      t.column :created_at, :timestamp, :null => false
      t.column :client_hostname, :string, :null => false
      t.column :iou, :string,    :null => false
      t.references :service_ticket
    end
  end

  def self.down
    drop_table :proxy_granting_tickets
    drop_table :ticket_granting_tickets
    drop_table :service_tickets
    drop_table :login_tickets
  end
end
