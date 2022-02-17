
import UIKit
import CoreData

class OnePictureViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewInScrollView: UIView!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var activIndicator: UIActivityIndicatorView!
    
    var imgURL = ""
    var imgId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }

    
    // Генерация текущей даты в стринг
    func generateDateString() -> String {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 10800)
        return formatter.string(from: time as Date)
    }
    
    
    //Загрузка картинки
    func loadImage() {
        activIndicator.startAnimating()
        let managedObjectOnePictureInfo = PictureInfo()
        let objects = managedObjectOnePictureInfo.getDataPictureInfo()
        
        //Проверка наличия картинки в базе и если есть, ее вывод
        for object in objects  as! [NSManagedObject] {
            guard let idInDB = (object.value(forKey: "id") as? Int) else {continue}
            if imgId == idInDB {
                //print("object.value(forKey: largeIMG): ", object.value(forKey: "largeIMG") as? Data)
                guard let imageData = (object.value(forKey: "largeIMG") ) else {
                    DispatchQueue.global(qos: .utility).async {
                        //if imageDataFronDB =
                        let urlImage = URL(string: self.imgURL)
                        guard let imageData = try? Data(contentsOf: urlImage!) else { return }
                        let image = UIImage(data: imageData)
                        //                        guard let dataForDB = image?.pngData() else {return}
                        //                        let managedObjectOnePictureInfo1 = PictureInfo()
                        // managedObjectOnePictureInfo1.setValue(dataForDB, forKey: "largeIMG")
                        //print("managedObjectOnePictureInfo.value(forKey: largeIMG: ", managedObjectOnePictureInfo.value(forKey: "largeIMG"))
                        // CoreDataManager.instance.saveImage(data: dataForDB)
                        //CoreDataManager.instance.saveContext()
                        DispatchQueue.main.async {
                            self.imageView.frame.size.width = image?.size.width ?? 0
                            self.imageView.frame.size.height = image?.size.height ?? 0
                            self.scrollView.contentSize = (image?.size)!
                            self.imageView.image = image
                            self.activIndicator.stopAnimating()
                            print("Picture loaded from internet")
                        }
                    }
                    return
                }
                print("id in DB: ", idInDB)
                let image = UIImage(data: imageData as! Data)
                self.imageView.frame.size.width = image?.size.width ?? 0
                self.imageView.frame.size.height = image?.size.height ?? 0
                self.scrollView.contentSize = (image?.size)!
                self.imageView.image = image
                self.updatedLabel.text = object.value(forKey: "savingDate") as? String
                self.activIndicator.stopAnimating()
                print("Picture loaded from db")
                return
            }
        }
        
        
        
        
    }
    
}
