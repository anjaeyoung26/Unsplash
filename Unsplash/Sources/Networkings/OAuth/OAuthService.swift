//
//  OAuthService.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/30.
//

import AuthenticationServices
import Foundation
import Moya
import RxMoya
import RxSwift


protocol OAuthServiceType {

  // MARK: - Properties

  var authenticationSession: ASWebAuthenticationSession? { get }

  var networking: Networking<OAuthAPI> { get }


  // MARK: - Methods

  func authorize(parameter: Parameter.Authorize) -> Single<String>

  func token(parameter: Parameter.Token) -> Single<Token>
}


// MARK: - OAuthService

final class OAuthService: NSObject, OAuthServiceType {

  // MARK: - Properties

  var authenticationSession: ASWebAuthenticationSession?

  var networking: Networking<OAuthAPI>


  // MARK: - Initializers

  init(networking: Networking<OAuthAPI>) {
    self.networking = networking
  }


  // MARK: - Methods

  func authorize(parameter: Parameter.Authorize) -> Single<String> {
    return .create { (observer: @escaping Single<String>.SingleObserver) -> Disposable in
      var component: URLComponents? = .init(string: "https://unsplash.com/oauth/authorize")
      component?.queryItems = [
        .init(name: "client_id", value: parameter.clientID),
        .init(name: "redirect_uri", value: parameter.redirectURI),
        .init(name: "response_type", value: parameter.responseType),
        .init(name: "scope", value: parameter.scope)
      ]

      guard let url: URL = component?.url else {
        observer(.error(MoyaError.requestMapping("oauth/authorize")))
        return Disposables.create()
      }

      self.authenticationSession = ASWebAuthenticationSession(
        url: url,
        callbackURLScheme: "unsplash",
        completionHandler: { (url: URL?, error: Error?) in
          if let code: String = url?.value(query: "code") {
            observer(.success(code))
          } else if let error {
            observer(.error(error))
          } else {
            observer(.error(RxError.unknown))
          }
        })
      self.authenticationSession?.presentationContextProvider = self
      self.authenticationSession?.start()

      return Disposables.create()
    }
  }

  func token(parameter: Parameter.Token) -> Single<Token> {
    return self.networking.rx
      .request(.token(parameter))
      .map { (response: Moya.Response) -> Token in
        switch response.statusCode {
        case 200...299:
          guard let token: Token = try? JSONDecoder().decode(Token.self, from: response.data) else {
            throw MoyaError.jsonMapping(response)
          }
          return token
        default:
          throw MoyaError.statusCode(response)
        }
      }
  }
}


// MARK: - URL Extension (Private)

private extension URL {

  func value(query: String) -> String? {
    guard let component: URLComponents = .init(string: self.absoluteString),
          let queryItems: [URLQueryItem] = component.queryItems else { return nil }

    return queryItems
      .first(where: { (item: URLQueryItem) -> Bool in item.name == query })
      .flatMap { (item: URLQueryItem) -> String? in return item.value }
  }
}


// MARK: - ASWebAuthenticationPresentationContextProviding

extension OAuthService: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return .init()
  }
}
