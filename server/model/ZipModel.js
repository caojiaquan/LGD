const Sequelize = require('sequelize');

//实例化对象
const INATANCE = require('./CommonModel/CommonModel');
//模型对象
const MODEL = INATANCE.define('t_zip_url', {
    id: {
        type: Sequelize.BIGINT,
        primaryKey: true
    },
    postman_name: Sequelize.STRING(100),
    postman_id: Sequelize.BIGINT,
    zip_src: Sequelize.STRING(100),
    upload_date: Sequelize.DATE,
    originalname: Sequelize.STRING,
    viewurl: Sequelize.STRING
}, {
        timestamps: false
    });

module.exports.add_pic = function(options){
    return INATANCE.query("insert into t_zip_urls (zip_src, originalname, viewurl) values ('"+ options.imgurl +"', '"+ options.originalname +"', '"+ options.viewurl +"')", 
        { type: INATANCE.QueryTypes.INSERT })
    .then(function (results) {
      return results;
    })
}
// 查询所有的图片
module.exports.select_pic = function(offset, limit, cb){
    INATANCE.query("select * from t_zip_urls order by upload_date desc limit " + offset + "," + limit, { type: INATANCE.QueryTypes.SELECT })
    .then(function (results) {
        cb && cb(results);
    })

}

// 图片总数
module.exports.select_pic_total = function(cb){
    var query =  INATANCE.query("select count(*) from t_zip_urls", { type: INATANCE.QueryTypes.SELECT })
    .then(function (results) {
        var row = results && results[0] && results[0]['count(*)'] || 0;
        cb && cb(row);
    })
}
