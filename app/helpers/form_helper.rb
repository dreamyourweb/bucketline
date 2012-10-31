module FormHelper

  def form_error_class(err)
    if !err.empty?
      return "error"
    else
      return nil
    end
  end

end
 
