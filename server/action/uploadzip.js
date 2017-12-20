const path = require('path');
const multer = require('multer');
const rootpath = process.cwd();
const zipModel = require('../model/ZipModel');
const shell = require('shelljs');
const fs = require('fs');
var adm_zip = require('adm-zip');

module.exports.get = function(req, res, next){
	var pageIdx = req && req.query && req.query.pageIdx || '';
	if(pageIdx){
		var limit = 10;
		var totalNum ;
		var data;
		zipModel.select_pic_total(function(data){
			totalNum = data;
		});
		var totalPage = Math.ceil(totalNum/limit);
		zipModel.select_pic((pageIdx-1)*limit, limit, function(data){
			res.send({data, totalNum});
		});
	}else{
    	res.render('LGD/page/uploadzip.tpl');
	}
}
module.exports.post = function (req, res, next) {
	var reqHost = 	req.headers.host;
	var url = './static/LGD/static/zip';
	var storage=multer.diskStorage({
			destination:function(req,file,cb){
				cb(null, url);
			},
			filename:function(req,file,cb){
				var fileFormat = (file.originalname).split(".");
		  		cb(null,  fileFormat[0] + parseInt(Math.random()*1000) + "." + fileFormat[fileFormat.length - 1]);
			}
	})
	var upload = multer({storage: storage}).any();
	upload(req, res, function(err){
		if(err){
			console.log(err);
		}
		for(var i=0; i<req.files.length; i++){
			var originalname = req.files[i].originalname;
			var imgurl = '/' + req.files[i].path.replace(/[\\]/g, '/');
			var filename = req.files[i].filename.split('.')[0];
			var zipurl = rootpath + '/static/LGD/static/zip/' + req.files[i].filename;
			var uzipurl = rootpath + '/static/LGD/static/zip/' + filename;
			var viewurl = '/static/LGD/static/zip/' + filename + '/index.html';
			var admzip = new adm_zip(zipurl);  
   			admzip.extractAllTo(uzipurl, /*overwrite*/true);


			var rows = zipModel.add_pic({
				imgurl, originalname, viewurl
			});
		}
		if(rows){
			res.redirect('/uploadzip');
		}

	});
}

