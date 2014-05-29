Fabricator(:payment) do
  user_id       { Fabricate(:user).id }
  amount        { 999 }
  reference_id  { 'some_reference_id' }
end