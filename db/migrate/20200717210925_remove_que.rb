class RemoveQue < ActiveRecord::Migration[5.2]
  def change
    Que.migrate!(version: 0)
  end
end
