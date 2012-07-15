class AddDontShowWizardToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :dont_show_wizard, :boolean

  end
end
