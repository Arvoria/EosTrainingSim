local TrainingService = {
}

function TrainingService:ResetState()
	print("Resetting state")
	return function(store)
		store:dispatch({
			type="SetId",
			guid = "",
		})
		store:dispatch({
			type="SetActive",
			game = {},
		})
	end
end

return TrainingService