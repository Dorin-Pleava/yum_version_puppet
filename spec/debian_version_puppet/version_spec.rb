require "yum_version_puppet"

describe YumVersionPuppet::Version do
  context "should fail if version cannot be parsed" do
    #FIXME
  end

  context "when creating new version" do
    it "is parsing basic version" do
      v = YumVersionPuppet::Version.parse('1:20191210.1-0ubuntu0.19.04.2')
      expect(v.epoch).to eql(1)
      expect(v.upstream_version).to eql('20191210.1')
      expect(v.yum_revision).to eql('0ubuntu0.19.04.2')
    end

    it "is parsing no epoch basic version" do
      v = YumVersionPuppet::Version.parse('20191210.1-0ubuntu0.19.04.2')
      expect(v.epoch).to eql(0)
      expect(v.upstream_version).to eql('20191210.1')
      expect(v.yum_revision).to eql('0ubuntu0.19.04.2')
    end

    it "is parsing no yum revision basic version" do
      v = YumVersionPuppet::Version.parse('2.42.1+19.04')
      expect(v.epoch).to eql(0)
      expect(v.upstream_version).to eql('2.42.1+19.04')
      expect(v.yum_revision).to eql(nil)
    end

    it "is parsing no epoch complex version" do
      v = YumVersionPuppet::Version.parse('3.32.2+git20190711-2ubuntu1~19.04.1')
      expect(v.epoch).to eql(0)
      expect(v.upstream_version).to eql('3.32.2+git20190711')
      expect(v.yum_revision).to eql('2ubuntu1~19.04.1')
    end

    it "is parsing even more complex version" do
      v = YumVersionPuppet::Version.parse('5:1.0.0+git-20190109.133f4c4-0ubuntu2')
      expect(v.epoch).to eql(5)
      expect(v.upstream_version).to eql('1.0.0+git-20190109.133f4c4')
      expect(v.yum_revision).to eql('0ubuntu2')
    end
  end
  context "when comparing two versions" do
    it "epoch has precedence" do
      first = YumVersionPuppet::Version.parse('9:99-99')
      second = YumVersionPuppet::Version.parse('10:01-01')
      expect(first < second).to eql(true)
    end
    it "handles equals letters-only versions" do
      lower = YumVersionPuppet::Version.parse('abd-def')
      higher = YumVersionPuppet::Version.parse('abd-def')
      expect(lower == higher).to eql(true)
    end
    it "shorter version is smaller" do
      lower = YumVersionPuppet::Version.parse('abd-de')
      higher = YumVersionPuppet::Version.parse('abd-def')
      expect(lower < higher).to eql(true)
    end
    it "shorter version is smaller even with digits" do
      lower = YumVersionPuppet::Version.parse('a1b2d-d3e')
      higher = YumVersionPuppet::Version.parse('a1b2d-d3ef')
      expect(lower < higher).to eql(true)
    end
    it "shorter version is smaller when number is less" do
      lower = YumVersionPuppet::Version.parse('a1b2d-d9')
      higher = YumVersionPuppet::Version.parse('a1b2d-d13')
      expect(lower < higher).to eql(true)
    end
    it "handles ~ version" do
      lower = YumVersionPuppet::Version.parse('a1b2d-d10~')
      higher = YumVersionPuppet::Version.parse('a1b2d-d10')
      expect(lower < higher).to eql(true)
    end
    it "handles letters versus -" do
      lower = YumVersionPuppet::Version.parse('a1b2d-d1a')
      higher = YumVersionPuppet::Version.parse('a1b2d-d1-')
      expect(lower < higher).to eql(true)
    end
  end
end
