class Product
  ALL = {
    cci: {
      small_rifle: {
        info: 'CCI No. 400',
        img: 'https://scheels.scene7.com/is/image/Scheels/07668350013?wid=400&hei=400&qlt=50'
      },
      small_rifle_magnum: {
        info: 'CCI No. 450',
        img: 'https://www.precisionreloading.com/img/products/CCI/CCI%20450%20Small%20Rifle%20Magnum%20Primers.jpg'
      },
      small_rifle_match: {
        info: 'CCI No. BR4 BR-4',
        img: 'https://cdn11.bigcommerce.com/s-dlp5xwiggc/products/69418/images/111983/076683000194__01184.1594663547.386.513.jpg?c=2'
      },
      small_rifle_aps: {
        info: 'CCI No. 400 APS',
        img: 'https://media.mwstatic.com/product-images/src/Primary/375/375560.jpg'
      }
    },
    federal: {
      small_rifle: {
        info: 'Federal 205',
        img: 'https://www.midsouthshooterssupply.com/images/product_images/129-205/129-205.jpg'
      },
    },
    # foo: {
    #   bar: {
    #     info: 'Test Listing',
    #     img: 'https://s3.amazonaws.com/backup-talend.appcohesion.io/DistributorMedia_S3/MSSBR-2NSQZKHI_LIP_MB65035.jpg'
    #   }
    # }
    # winchester: {
    #   pistol: {
    #   },
    #   rifle: {
    #   }
    # },
    # remington: {
    #   pistol: {
    #   },
    #   rifle: {
    #   }
    # }
  }.with_indifferent_access
end
