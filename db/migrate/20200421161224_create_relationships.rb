class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # relationshipsテーブルは中間テーブルなので、user_idとfollow_idは「t.references」で作る必要がある。
      # そして、外部キーとしての設定をするためにオプションは「foreign_key: true」とします。
      # foreign_key: trueにすると存在しないfollowsテーブルを参照してしまうため、follow_idの参照先のテーブルはusersテーブルにしてあげたいので、{to_table: :users}とする。
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      
      # user_id と follow_id のペアで重複するものが保存されないようにするデータベースの設定
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
