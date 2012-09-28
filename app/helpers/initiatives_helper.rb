module InitiativesHelper
	def initiatives_to_sentence(initiatives)
		sentence = []
		initiatives.each do |initiative|
			sentence << initiative.name
		end
		sentence.to_sentence
	end
end
