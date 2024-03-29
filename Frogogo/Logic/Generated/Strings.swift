// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Error {
    /// Что то пошло не так :(
    internal static let server = L10n.tr("Localizable", "Error.server")
  }

  internal enum Alert {
    /// Выход
    internal static let titleActionExit = L10n.tr("Localizable", "alert.title_Action_exit")
    /// Ok
    internal static let titleActionOk = L10n.tr("Localizable", "alert.title_Action_ok")
    /// Ошибка
    internal static let titleError = L10n.tr("Localizable", "alert.title_Error")
    /// Успех
    internal static let titleSuccess = L10n.tr("Localizable", "alert.title_Success")
  }

  internal enum FormUser {
    /// Для того что бы продолжить введите корректную почту :(
    internal static let errorEmail = L10n.tr("Localizable", "formUser.error_email")
    /// Для того что-бы продолжить, заполните пожалуйста все поля :(
    internal static let errorEmptyFields = L10n.tr("Localizable", "formUser.error_emptyFields")
    /// Пользователь успешно был добавлен в список :)
    internal static let successAdd = L10n.tr("Localizable", "formUser.success_add")
    /// Изменения сохранены :)
    internal static let successEdit = L10n.tr("Localizable", "formUser.success_edit")
    internal enum Input {
      /// Почта
      internal static let email = L10n.tr("Localizable", "formUser.input.email")
      /// Имя
      internal static let firstName = L10n.tr("Localizable", "formUser.input.firstName")
      /// Фамилия
      internal static let lastName = L10n.tr("Localizable", "formUser.input.lastName")
      /// Аватар url
      internal static let urlAvatar = L10n.tr("Localizable", "formUser.input.urlAvatar")
    }
    internal enum Title {
      /// Добавить
      internal static let add = L10n.tr("Localizable", "formUser.title.add")
      /// Редактировать
      internal static let edit = L10n.tr("Localizable", "formUser.title.edit")
    }
    internal enum Validation {
      /// Некорректный адрес почты
      internal static let errorEmail = L10n.tr("Localizable", "formUser.validation.error_email")
      /// Некорректный адрес url
      internal static let errorUrl = L10n.tr("Localizable", "formUser.validation.error_url")
    }
  }

  internal enum ListUsers {
    /// Дата: %@
    internal static func date(_ p1: String) -> String {
      return L10n.tr("Localizable", "listUsers.date", p1)
    }
    /// Почта: %@
    internal static func email(_ p1: String) -> String {
      return L10n.tr("Localizable", "listUsers.email", p1)
    }
    /// Пусто
    internal static let emptyTitle = L10n.tr("Localizable", "listUsers.empty_title")
    /// Имя: %@
    internal static func name(_ p1: String) -> String {
      return L10n.tr("Localizable", "listUsers.name", p1)
    }
    /// Пользователи
    internal static let title = L10n.tr("Localizable", "listUsers.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
