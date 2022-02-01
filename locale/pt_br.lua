local Translations = {
    telegram  = {
        post_office = 'Telégrafo',
        first_name = 'Nome do destinatário: ',
        last_name = 'Sobrenome do destinatário: ',
        message = 'Messagem: ',
        no_telegrams = 'Não há telegramas para você.',
        press_to_view = 'Pressione %{value} para ler seus telegramas.',
        telegram_posted = 'Seu telegrama foi enviado.',
        unable_to_process = 'Não foi possível processar seu Telegrama. Tente novamente mais tarde.',
        unable_to_deleted = 'Não foi possível excluir seu Telegrama. Tente novamente mais tarde.',
        invalid_name = 'Impossível enviar o Telegrama. Nome ou Sobrenome inválido.'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})