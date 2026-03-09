import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://api.ruandev.com" // Será configurável
    private var token: String? {
        UserDefaults.standard.string(forKey: "userToken")
    }
    
    // MARK: - Authentication
    
    func login(key: String, packageToken: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/auth/login-with-key"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["key": key, "packageToken": packageToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                UserDefaults.standard.set(response.token, forKey: "userToken")
                UserDefaults.standard.set(response.userId, forKey: "userId")
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Keys
    
    func getKeyInfo(keyId: String, completion: @escaping (Result<APIKey, Error>) -> Void) {
        guard let token = token else {
            completion(.failure(NSError(domain: "APIService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No token"])))
            return
        }
        
        let endpoint = "\(baseURL)/keys/\(keyId)"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1)))
                return
            }
            
            do {
                let key = try JSONDecoder().decode(APIKey.self, from: data)
                completion(.success(key))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getUserKeys(completion: @escaping (Result<[APIKey], Error>) -> Void) {
        guard let token = token else {
            completion(.failure(NSError(domain: "APIService", code: -2)))
            return
        }
        
        let endpoint = "\(baseURL)/keys/my-keys"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1)))
                return
            }
            
            do {
                let keys = try JSONDecoder().decode([APIKey].self, from: data)
                completion(.success(keys))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Devices
    
    func registerDevice(udid: String, keyId: String, completion: @escaping (Result<Device, Error>) -> Void) {
        guard let token = token else {
            completion(.failure(NSError(domain: "APIService", code: -2)))
            return
        }
        
        let endpoint = "\(baseURL)/devices/register"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "udid": udid,
            "keyId": keyId,
            "deviceName": UIDevice.current.name,
            "osVersion": UIDevice.current.systemVersion,
            "modelName": UIDevice.current.model
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1)))
                return
            }
            
            do {
                let device = try JSONDecoder().decode(Device.self, from: data)
                completion(.success(device))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getDevices(completion: @escaping (Result<[Device], Error>) -> Void) {
        guard let token = token else {
            completion(.failure(NSError(domain: "APIService", code: -2)))
            return
        }
        
        let endpoint = "\(baseURL)/devices/my-devices"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1)))
                return
            }
            
            do {
                let devices = try JSONDecoder().decode([Device].self, from: data)
                completion(.success(devices))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - UDID
    
    func getUDID() -> UDIDInfo? {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return UDIDInfo(
            udid: udid,
            deviceName: UIDevice.current.name,
            osVersion: UIDevice.current.systemVersion,
            modelName: UIDevice.current.model
        )
    }
}

struct LoginResponse: Codable {
    let token: String
    let userId: String
    let username: String
    let email: String
}
