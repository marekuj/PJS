from __future__ import print_function
import sys
import os
import subprocess
import shutil
import platform

if sys.version_info >= (2, 7):
    import argparse
else:
    import optparse
    class HolderOfMonkeyPatch(object):
        pass

    def alignment_of_parse_args_method_to_version_from_argparse(self, arguments):
        (parsed_arguments, _) = self.parse_args_base(arguments)
        return parsed_arguments

    argparse = HolderOfMonkeyPatch()
    argparse.ArgumentParser = optparse.OptionParser
    argparse.ArgumentParser.add_argument = optparse.OptionParser.add_option
    argparse.ArgumentParser.parse_args_base = optparse.OptionParser.parse_args
    argparse.ArgumentParser.parse_args = alignment_of_parse_args_method_to_version_from_argparse


class SpecFile(object):

    def __init__(self, project_root_path, spec_path):
        self.spec_path = spec_path
        self.project_root_path = project_root_path
        self.distribution = self._select_distribution()
        self.name = None
        self.version = None
        self.release = None
        self.architecture = None
        self.package_name = None
        line_parsers = [
                        ('Name:', lambda self, line: setattr(self, 'name', line.split(':')[1].strip())),
                        ('Version:', lambda self, line: setattr(self, 'version', line.split(':')[1].strip())),
                        ('Release:', lambda self, line: setattr(self, 'release', line.split(':')[1].strip().split('%')[0])),
                        ('BuildArch:', lambda self, line: setattr(self, 'architecture', line.split(':')[1].strip()))
        ]
        with open(spec_path) as f:
            for line in f:
                for pattern, extraction in line_parsers:
                    if line.find(pattern) != -1:
                         extraction(self, line)
        self.package_name = '{0}-{1}-{2}.{3}.{4}.rpm'.format(
                                            self.name,
                                            self.version,
                                            self.release,
                                            self.distribution,
                                            self.architecture
        )

        self.package_devel_name = '{0}-devel-{1}-{2}.{3}.{4}.rpm'.format(
                                              self.name,
                                              self.version,
                                              self.release,
                                              self.distribution,
                                              self.architecture
        )

        self.package_debuginfo_name = '{0}-debuginfo-{1}-{2}.{3}.{4}.rpm'.format(
                                              self.name,
                                              self.version,
                                              self.release,
                                              self.distribution,
                                              self.architecture
        )

    def __str__(self):
        return 'Spec file path: {0}\n' \
               'Project root path: {1}\n' \
               'Name: {2}\n' \
               'Version: {3}\n' \
               'Release: {4}\n' \
               'Distribution: {5}\n' \
               'Architecture: {6}\n' \
               'Package name: {7}\n' \
               'Devel package name: {8}\n' \
               'DebugInfo package name: {9}\n'.format(
                                            self.spec_path,
                                            self.project_root_path,
                                            self.name,
                                            self.version,
                                            self.release,
                                            self.distribution,
                                            self.architecture,
                                            self.package_name,
                                            self.package_devel_name,
                                            self.package_debuginfo_name)

    def _select_distribution(self):
        version = int(float(platform.dist()[1]))
        if version == 6:
            return 'el6'
        elif version == 7:
            return 'el7'


def create_tar(spec):
    original_caller_directory = os.getcwd()
    files_to_tar = ' '.join(os.listdir(spec.project_root_path))
    tar_path = os.path.join(
                    original_caller_directory, 
                    '{0}-{1}.tar.gz'.format(spec.name, spec.version))
    os.chdir(spec.project_root_path) 
    tar_command = 'tar -zcvf {0} {1}'.format(tar_path, files_to_tar)

    tar_process = subprocess.Popen(tar_command.split(), stdout=subprocess.PIPE)
    stdout, stderr = tar_process.communicate() 
    print(stdout)
    os.chdir(original_caller_directory)
    return tar_path


def extract_spec_files(path):
    spec_files = list()
    full_path = os.path.abspath(path)
    for root, subdirs, files in os.walk(path):
        for filename in files:
            if filename.endswith('.spec'):
                spec_files.append(SpecFile(path, os.path.join(root, filename)))
    if len(spec_files) == 0:
        raise RuntimeError('THERE IS NO SPEC FILE IN PROJECT RPM SUBDIR')
    return spec_files


def load_cert(cert_shortcut):
    cert_map = {'ZSB': 'ZSB TEAM RELEASE', 'EXT': 'EXTERNAL CODE ZSB TEAM RELEASE'};
    if cert_shortcut and cert_shortcut in cert_map:
        return cert_map[cert_shortcut]
    return None


def select_spec_files(spec_files, build_all_flag):
    if build_all_flag or len(spec_files) <= 1:
        return spec_files
    
    print('\nPlease select what to build:')
    for i, item in enumerate(spec_files):
        print('{0}) '.format(i+1) + item.spec_path)
    
    user_input = raw_input('Enter choice(default: All): ')
    if user_input == '':
        return spec_files
    else:
        try:
            selected_spec_files = list()
            selected_spec_files.append(spec_files[int(user_input) - 1])
            return selected_spec_files
        except IndexError:
            raise RuntimeError('INDEX WHICH DONT EXIST WAS SELECETED')


def post_process_built_packages(
        package_name,
        architecture, 
        source_directory,
        target_directory):

    built_package_path = os.path.join(
                            source_directory,
                            architecture,
                            package_name)

    if os.path.exists(built_package_path):
        shutil.copy(built_package_path, target_directory)
        os.chmod(os.path.join(target_directory, package_name), 0664)


def main(args):
    parser = argparse.ArgumentParser(description='Tool is a builder for RPMs based on passed directory of project'
                                                 'There is one requirement, passed directory must have subdirectory'
                                                 'called \'rpm\' with SPEC files in it')
    parser.add_argument('-d', '--directory_of_project',
            dest='project_directory',
            help='Path to directory of project which we want to build')
    parser.add_argument('--rpmbuild_dir',
            dest='rpmbuild_directory',
            help='Path to rpmbuild directory',
            default='/home/builder/rpmbuild')
    parser.add_argument('--rpm_store_dir',
            dest='rpm_store_directory',
            help='Path where built RPMs will be stored',
            default='/tmp')
    parser.add_argument('--build_all',
            dest='build_all_flag',
            action='store_true',
            help='Flag for building all packages from project without asking',
            default=False)
    
    args = parser.parse_args(args[1:])
    
    if not args.project_directory:
        raise RuntimeError('--directory_of_project is mandatory parameter')

    rpmbuilder_source_directory = os.path.join(args.rpmbuild_directory, 'SOURCES')
    rpmbuilder_spec_directory = os.path.join(args.rpmbuild_directory, 'SPECS')
    rpmbuilder_rpms_directory = os.path.join(args.rpmbuild_directory, 'RPMS')
    rpm_store_directory = args.rpm_store_directory
    project_root_directory = args.project_directory

    if not os.path.exists(project_root_directory):
        raise RuntimeError('PASSED PROJECT DIRECTORY DOES NOT EXIST')

    spec_files = select_spec_files(extract_spec_files(project_root_directory), 
                                   args.build_all_flag)
 
    for spec in spec_files:
        print(spec)
        tar_path = create_tar(spec)
        shutil.copy(tar_path, rpmbuilder_source_directory)
        shutil.copy(spec.spec_path, rpmbuilder_spec_directory)
         
        rpmbuilder_spec_file_path = os.path.join(rpmbuilder_spec_directory, os.path.basename(spec.spec_path))
        rpmbuild_command = 'rpmbuild -bb {0}'.format(rpmbuilder_spec_file_path)
        rpmbuild_process = subprocess.Popen(rpmbuild_command.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        while rpmbuild_process.poll() is None:
            line = rpmbuild_process.stdout.readline()
            sys.stdout.write(line)    
       
        post_process_built_packages(
            spec.package_name,
            spec.architecture,
            rpmbuilder_rpms_directory,
            rpm_store_directory)
            
        post_process_built_packages(
            spec.package_devel_name,
            spec.architecture,
            rpmbuilder_rpms_directory,
            rpm_store_directory)

        post_process_built_packages(
            spec.package_debuginfo_name,
            spec.architecture,
            rpmbuilder_rpms_directory,
            rpm_store_directory)


if __name__ == "__main__":
    main(sys.argv)
