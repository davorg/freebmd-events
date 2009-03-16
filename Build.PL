use Module::Build;

my $build = Module::Build->new(
			       module_name => 'FreeBMD::Events',
			       license     => 'perl',
			       requires    => {
                                 'perl'                => '5.008',
                               },
			       build_requires => {
                                 'Test::More'          => '0.47',
                               },
                               build_recommends => {
                                 'Test::Pod'           => 0,
                                 'Test::Pod::Coverage' => 0,
                               },               
			       create_makefile_pl => 'traditional',
);

$build->create_build_script;
