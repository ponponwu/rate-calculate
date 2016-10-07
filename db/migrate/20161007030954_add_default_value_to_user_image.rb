class AddDefaultValueToUserImage < ActiveRecord::Migration
  def change
    change_column :users, :image, :string, default: 'https://s.gravatar.com/avatar/5c7cf1d8890b068ed406aa4ed011b9db?d=mm'
  end
end
