local Translations = {
    telegram  = {
        post_office = 'Post Office',
        first_name = 'Recipient\'s Firstname: ',
        last_name = 'Recipient\'s Lastname: ',
        message = 'Message: ',
        no_telegrams = 'No telegrams to display.',
        press_to_view = 'Press %{value} to view your telegrams.',
        telegram_posted = 'Your telegram has been posted.',
        unable_to_process = 'We\'re unable to process your Telegram right now. Please try again later.',
        unable_to_deleted = 'We\'re unable to delete your Telegram right now. Please try again later.',
        invalid_name = 'Unable to process Telegram. Invalid first or lastname.'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})