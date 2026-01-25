use async_openai::{error::OpenAIError, types::chat::*, Client};

pub async fn open_ai() -> Result<Option<String>, OpenAIError> {
    let client = Client::new();

    let system_message = ChatCompletionRequestSystemMessageArgs::default()
        .content("You are are an adhd guru particularly with programmers and you know how to peek their interests by offering some neat things for their brains to hyper focus on.")
        .build()?;

    let user_message = ChatCompletionRequestUserMessageArgs::default()
        .content("Provide a piece of advice.")
        .build()?;

    let request = CreateChatCompletionRequestArgs::default()
        .model("gpt-4")
        .messages([
            ChatCompletionRequestMessage::System(system_message),
            ChatCompletionRequestMessage::User(user_message),
        ])
        .build()?;

    let response = client.chat().create(request).await?;

    let content = response
        .choices
        .get(0)
        .and_then(|c| c.message.content.clone()); // Option<String>

    Ok(content)
}
