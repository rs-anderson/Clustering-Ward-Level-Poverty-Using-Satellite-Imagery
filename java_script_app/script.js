var map;
function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: -26.4946, lng: 27.868 },
    zoom: 14,
    mapTypeId: 'satellite'
  });

  // Define the LatLng coordinates for the polygon's path.
    // var triangleCoords = [
    //   {lat: -26.48715, lng: 27.8377},
    //   {lat: -26.48715, lng: 27.8463},
    //   {lat: -26.49485, lng: 27.8463},
    //   {lat: -26.49485, lng: 27.8377}
    // ];
    //
    // (-26.479170238999927,
    var bounds = {
      north: -26.479170238999927,
      south: -26.49485,
      east: 27.8463,
      west: 27.824467997000056
    };

    // (-26.479170238999927,
    //  -26.50463912699996,
    //  27.87418553400005,
    //  27.824467997000056)
    //
    //  Lat =-26.481095238999934
    //  Lng = 27.826617997000053

    var y_rad = 0.00385
    var x_rad = 0.0043

    var bounds_ward = {
      north: -26.479170238999927,
      south: -26.50463912699996,
      east: 27.87418553400005,
      west: 27.824467997000056
    };

    var bounds1 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad,
      west: 27.824467997000056
    };

    var bounds2 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad + 2*x_rad,
      west: 27.824467997000056 + 2*x_rad
    };

    var bounds3 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad + 2*x_rad + 2*x_rad,
      west: 27.824467997000056 + 2*x_rad + 2*x_rad
    };

    var bounds4 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad,
      west: 27.824467997000056 + 2*x_rad + 2*x_rad + 2*x_rad
    };

    var bounds5 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad,
      west: 27.824467997000056 + 2*x_rad + 2*x_rad + + 2*x_rad + 2*x_rad
    };

    var bounds6 = {
      north: -26.479170238999927,
      south: -26.479170238999927 - 2*y_rad,
      east: 27.824467997000056 + 2*x_rad + 2*x_rad+ 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad,
      west: 27.824467997000056 + 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad + 2*x_rad
    };

    // // Construct the polygon.
    // var rectangle1 = new google.maps.Rectangle({
    //   bounds: bounds,
    //   strokeColor: '#FF0000',
    //   strokeOpacity: 0.8,
    //   strokeWeight: 2,
    //   fillColor: '#FF0000',
    //   fillOpacity: 0.35,
    //   draggable: true,
    //   zIndex: 1
    // });
    // rectangle1.setMap(map);

    rect = new google.maps.Rectangle({
     bounds: bounds_ward,
     strokeColor: '#FF0000',
     strokeOpacity: 0.8,
     strokeWeight: 2,
     fillColor: '#FF0000',
     fillOpacity: 0.1,
     draggable: false,
     zIndex: 1
   });
   rect.setMap(map);


   rect1 = new google.maps.Rectangle({
    bounds: bounds1,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.3,
    draggable: false,
    zIndex: 1
  });
  rect1.setMap(map);

  google.maps.event.addListener(rect1, 'dragend', function() {
      var lat = rect1.getBounds().getCenter().lat();
      var lng = rect1.getBounds().getCenter().lng();
      console.log("Lat =" + lat);
      console.log("Lng = " + lng);
    });

    rect2 = new google.maps.Rectangle({
     bounds: bounds2,
     strokeColor: '#FF0000',
     strokeOpacity: 0.8,
     strokeWeight: 2,
     fillColor: '#FF0000',
     fillOpacity: 0.3,
     draggable: true,
     zIndex: 1
   });
   rect2.setMap(map);

   google.maps.event.addListener(rect2, 'dragend', function() {
       var lat = rect2.getBounds().getCenter().lat();
       var lng = rect2.getBounds().getCenter().lng();
       console.log("Lat =" + lat);
       console.log("Lng = " + lng);
     });

     rect3 = new google.maps.Rectangle({
      bounds: bounds3,
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.3,
      draggable: true,
      zIndex: 1
    });
    rect3.setMap(map);

    google.maps.event.addListener(rect3, 'dragend', function() {
        var lat = rect3.getBounds().getCenter().lat();
        var lng = rect3.getBounds().getCenter().lng();
        console.log("Lat =" + lat);
        console.log("Lng = " + lng);
      });

      rect4 = new google.maps.Rectangle({
       bounds: bounds4,
       strokeColor: '#FF0000',
       strokeOpacity: 0.8,
       strokeWeight: 2,
       fillColor: '#FF0000',
       fillOpacity: 0.3,
       draggable: true,
       zIndex: 1
     });
     rect4.setMap(map);

     google.maps.event.addListener(rect4, 'dragend', function() {
         var lat = rect4.getBounds().getCenter().lat();
         var lng = rect4.getBounds().getCenter().lng();
         console.log("Lat =" + lat);
         console.log("Lng = " + lng);
       });



       rect5 = new google.maps.Rectangle({
        bounds: bounds5,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.3,
        draggable: true,
        zIndex: 1
      });
      rect5.setMap(map);

      google.maps.event.addListener(rect5, 'dragend', function() {
          var lat = rect5.getBounds().getCenter().lat();
          var lng = rect5.getBounds().getCenter().lng();
          console.log("Lat =" + lat);
          console.log("Lng = " + lng);
        });


        rect6 = new google.maps.Rectangle({
         bounds: bounds6,
         strokeColor: '#FF0000',
         strokeOpacity: 0.8,
         strokeWeight: 2,
         fillColor: '#FF0000',
         fillOpacity: 0.3,
         draggable: true,
         zIndex: 1
       });
       rect6.setMap(map);

       google.maps.event.addListener(rect6, 'dragend', function() {
           var lat = rect6.getBounds().getCenter().lat();
           var lng = rect6.getBounds().getCenter().lng();
           console.log("Lat =" + lat);
           console.log("Lng = " + lng);
         });

    // var rectangles = [];
    //
    // for (var i=0; i<7; i++){
    //   rectangles.push(
    //     new google.maps.Rectangle({
    //      bounds: bounds,
    //      strokeColor: '#FF0000',
    //      strokeOpacity: 0.8,
    //      strokeWeight: 2,
    //      fillColor: '#FF0000',
    //      fillOpacity: 0.35,
    //      draggable: true,
    //      zIndex: 1
    //    })
    //   );
    //
    //   rectangles[i].setMap(map);
    //   console.log(i);
    // };
    //
    // for (rectangle of rectangles){
    //   google.maps.event.addListener(rectangle, 'dragend', function() {
    //     var lat = rectangle.getBounds().getCenter().lat();
    //     var lng = rectangle.getBounds().getCenter().lng();
    //     console.log("Lat =" + lat);
    //     console.log("Lng = " + lng);
    //   });
    // }
    loadMapShapes();


}

/** Loads the state boundary polygons from a GeoJSON source. */
function loadMapShapes() {
  // load US state outline polygons from a GeoJSON file
  map.data.loadGeoJson('../electoral wards for jhb.json', { idPropertyName: 'WARDNO' });
}
