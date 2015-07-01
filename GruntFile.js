module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      files: '*.pde',
      tasks: 'concat'
    },

    concat: {
      options: {
        separator: '\n \n',
      },
      dist: {
        src: "*.pde",
        dest: 'web-export/FilterTrab3.pde',
      },
    },
  });

  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.registerTask('default', ['watch']);
};
