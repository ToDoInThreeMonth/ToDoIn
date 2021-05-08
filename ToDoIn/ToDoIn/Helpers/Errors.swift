import Foundation

enum СustomError: String, Error {
    case emptyInput = "Пожалуйста, заполните все поля"
    case differentPasswords = "Вы ввели разные пароли"
    case incorrectPassword = "Пожалуйста, убедитесь, что Ваш пароль содержит хотя бы 6 символа"
    
    case error = "Ошика"
    case unexpected = "Неизвестная ошибка"
    case noSignedUser = "Пользователь не авторизирован"
    case noUser = "Неверный логин или пароль"
    case failedToCreateUser = "Эта почта уже занята"
    case failedToSaveUserInFireStore = "Не удалось сохранить данные пользователя"
    
    func toString() -> String {
        self.rawValue
    }
}
