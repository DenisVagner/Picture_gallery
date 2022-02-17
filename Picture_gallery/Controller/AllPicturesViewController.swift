
import UIKit
import CoreData

class AllPicturesViewController: UIViewController {
    
    @IBOutlet weak var pictureListTableView: UITableView!
    
    var result: AllPicturesModel? = nil
    var currentPage = 1
    let networkRequestAF = NetworkRequest()
    let myAPIkey = "25730613-389082327161724831bab0d17"
    var urlString: String {
        get {
            "https://pixabay.com/api/?key=25730613-389082327161724831bab0d17&q=yellow+flowers&image_type=photo&page=\(currentPage)"
        }
    }
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromNetworkAF(url: urlString)
        // Do any additional setup after loading the view.
    }
    
    
    // Запрос данных о 20 картинках
    func loadFromNetworkAF(url: String) {
        networkRequestAF.requestAll(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let allPictures):
                if self?.result == nil {
                    self?.result = allPictures
//                    for i in 0...((self?.result!.hits.count)! - 1) {
//                        self!.setValuesPictureInfo(index: i)
//                    }
                    
                } else {
                    self?.result?.hits += allPictures.hits
                }
                self?.pictureListTableView.reloadData()
            case .failure(let error):
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", error)
            }
        }
    }
    
    // Генерация текущей даты в стринг
    func generateDateString() -> String {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 10800)
        return formatter.string(from: time as Date)
    }
    
    
    
    //MARK: Установка значения атрибутов
    func setValuesPictureInfo (index: Int){
        let managedObjectOnePictureInfo = PictureInfo()
        let objects = getDataPictureInfo()
        var exist = false
        for object in objects as! [NSManagedObject] {
            if self.result?.hits[index].id == (object.value(forKey: "id") as? Int) {
//                object.setValue(self.result?.hits[index].largeImageURL ?? "", forKey: "largeImageURL")
//                object.setValue(self.result?.hits[index].previewURL ?? "", forKey: "previewURL")
//                let date = self.generateDateString()
//                object.setValue(date, forKey: "savingDate")
                exist = true
                break
            }
        }
        if !exist {
            DispatchQueue.global(qos: .background).async {
                managedObjectOnePictureInfo.setValue(self.result?.hits[index].id ?? 0, forKey: "id")
    //            managedObjectOnePictureInfo.setValue(self.result?.hits[index].views ?? 0, forKey: "views")
    //            managedObjectOnePictureInfo.setValue(self.result?.hits[index].imageWidth ?? 0, forKey: "imageWidth")
    //            managedObjectOnePictureInfo.setValue(self.result?.hits[index].imageHeight ?? 0, forKey: "imageHeight")
                managedObjectOnePictureInfo.setValue(self.result?.hits[index].largeImageURL ?? "", forKey: "largeImageURL")
                managedObjectOnePictureInfo.setValue(self.result?.hits[index].previewURL ?? "", forKey: "previewURL")
                let date = self.generateDateString()
                managedObjectOnePictureInfo.setValue(date, forKey: "savingDate")
            
                guard let urlImage = URL(string: self.result?.hits[index].largeImageURL ?? "") else {return}
                guard let imageData = try? Data(contentsOf: urlImage) else { return }
                let image = UIImage(data: imageData)
                guard let dataForDB = image?.pngData() else {return}
                managedObjectOnePictureInfo.setValue(dataForDB, forKey: "largeIMG")
            }
        }
                
        // Запись объекта
        CoreDataManager.instance.saveContext()
        print("Data saved PictureInfo")

    }
    
    
    // Извлечение записей
    func getDataPictureInfo() -> [NSFetchRequestResult] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }catch {
            print(error)
            return []
        }
    }
    
    
    
    // Передача названия ссылки нажатой картинки на следующий экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = pictureListTableView.indexPath(for: cell) {
            if let vc = segue.destination as? OnePictureViewController, segue.identifier == "ShowOne" {
                vc.imgURL = result?.hits[index.row].largeImageURL ?? ""
                vc.imgId = result?.hits[index.row].id ?? 0
                print("id: ", result?.hits[index.row].id ?? 0)
                self.setValuesPictureInfo(index: index.row)
                //                let cityData = getDataCitiesInFavorite()
                //                let object1 = cityData[index.row] as! NSManagedObject
                //                vc.currentCity = object1.value(forKey: "name_en") as! String
            }
        }
    }
    
    func downloadSmallImages(urlStringSmallImage: String) {
        let urlImage = URL(string: urlStringSmallImage)
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let imageData = try? Data(contentsOf: urlImage!) {
                let image = UIImage(data: imageData)
                    self.imageCache.setObject(image!, forKey: urlStringSmallImage as AnyObject)
            }
        }
    }
    
    
}

//MARK: Table setup

extension AllPicturesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //let picturesCount = getDataPictureInfo()
        //return picturesCount.count
         return result?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AllPicturesTableViewCell
        //setValuesPictureInfo(index: indexPath.row)
        
        
        // заполнение лейблов
        if let currentPictureInfo = result?.hits[indexPath.row] {
            cell.viewsLabel.text = "\(currentPictureInfo.views ?? 0)"
            cell.imageResolution.text = "\(currentPictureInfo.imageWidth ?? 0)x\(currentPictureInfo.imageHeight ?? 0)"
            cell.imageSize.text = "\((currentPictureInfo.imageSize ?? 0) / 1048576) MB"
            //            let num = String( Double( (Double(currentPictureInfo.imageSize ?? 0)) / 1048576))
            //            let first3 = num.substring(to: num.index(num.startIndex, offsetBy: 3))
            //            cell.imageSize.text = "\(first3) MB"
        }
        
        
        
        // Пагинация
        if (indexPath.row + 1) == result?.hits.count {
            currentPage += 1
            DispatchQueue.global(qos: .utility).async {
                self.loadFromNetworkAF(url: self.urlString)
            }
        }
        
        // вывод изображения
        if let urlStringImage = self.result?.hits[indexPath.row].previewURL {
            cell.activInd.startAnimating()
            
            // проверка на наличие изображения в кэше, если есть - грузить с него, если нет, то загружать картинку, выводить и затем помещать в кэш
            if let image = self.imageCache.object(forKey: urlStringImage as AnyObject) as? UIImage {
                cell.cellImageView.image = image
                print("Image \(indexPath.row + 1) loaded from cache")
                cell.activInd.stopAnimating()
            } else {
//                downloadSmallImages(urlStringSmallImage: urlStringImage)
                let urlImage = URL(string: urlStringImage)
                let queue = DispatchQueue.global(qos: .utility)
                queue.async {
                    if let imageData = try? Data(contentsOf: urlImage!) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            cell.cellImageView.image = image
                            self.imageCache.setObject(image!, forKey: urlStringImage as AnyObject)
                            print("Image \(indexPath.row + 1) downloaded")
                            cell.activInd.stopAnimating()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    
    // Убирает выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

