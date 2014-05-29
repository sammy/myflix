class Payment < ActiveRecord::Base
  
  belongs_to :user


  def user_full_name
    user.full_name
  end

  def user_email
    user.email
  end

  def amount_to_decimal
    display_amount = amount.to_f/100
    "$ #{display_amount}"
  end
end